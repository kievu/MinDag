import UIKit
import ResearchKit

private let dailyFormIndex = 0

private extension NSDate {
    func isBeforeToday() -> Bool {
        let midnight = NSCalendar.currentCalendar().dateBySettingHour(
            0, minute: 0, second: 0, ofDate: NSDate(), options: NSCalendarOptions())!
        return self.timeIntervalSinceDate(midnight) <= 0
    }
}

class TaskListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingsIcon: UIBarButtonItem!
    
    let taskListRows = TaskListRow.allCases
    let dailyFormIcon = "crescentmoon"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        animateSettingsIconWithDuration(1.7)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TaskListViewController.presentDailySurvey), name: "dailySurvey", object: nil)
        
        // Register custom cell
        let nib = UINib(nibName: "TaskTableViewCellView", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Default")
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.viewWillEnterForeground), name: UIApplicationWillEnterForegroundNotification, object: UIApplication.sharedApplication())
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func viewWillEnterForeground() {
        tableView.reloadData()
    }
    
    func taskDisabled(taskIndex: Int) -> Bool {
        return taskIndex == dailyFormIndex ? !dailyFormAvailable() : false
    }
    
    func dailyFormAvailable() -> Bool {
        if let lastDeliveryTime = UserDefaults.valueForKey(UserDefaultKey.lastDailyFormTime) as? NSDate {
            return lastDeliveryTime.isBeforeToday()
        }
        
        return true
    }
    
    func createAlertController(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        return alertController
    }
    
    func showAlert(title: String, message: String) {
        presentViewController(createAlertController(title, message: message), animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, taskViewController: ORKTaskViewController) {
        taskViewController.presentViewController(createAlertController(title, message: message), animated: true, completion: nil)
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskListRows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Default", forIndexPath: indexPath) as! TaskTableViewCell
        let taskListRow = taskListRows[indexPath.row]
        
        cell.titleLabel.text = "\(taskListRow)"
        cell.iconLabel.text = dailyFormIcon
        
        if taskDisabled(indexPath.row) {
            cell.iconLabel.textColor = Color.disabledColor
            cell.userInteractionEnabled = false
        } else {
            cell.iconLabel.textColor = Color.primaryColor
            cell.userInteractionEnabled = true
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 170
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if !Reachability.isConnected() { showAlert("INTERNET_UNAVAILABLE_TITLE".localized, message: "INTERNET_UNAVAILABLE_TEXT".localized) }
        
        // Present the task view controller that the user asked for.
        let taskListRow = taskListRows[indexPath.row]
        
        // Create a task from the `TaskListRow` to present in the `ORKTaskViewController`.
        let task = taskListRow.representedTask
        
        /*
        Passing `nil` for the `taskRunUUID` lets the task view controller
        generate an identifier for this run of the task.
        */
        let taskViewController = ORKTaskViewController(task: task, taskRunUUID: nil)
        
        // Make sure we receive events from `taskViewController`.
        taskViewController.delegate = self
        
        presentViewController(taskViewController, animated: true, completion: nil)
    }
    
    func presentDailySurvey() {
        let taskListRow = taskListRows[0]
        let task = taskListRow.representedTask
        let taskViewController = ORKTaskViewController(task: task, taskRunUUID: nil)
        taskViewController.delegate = self
        navigationController?.topViewController?.presentViewController(taskViewController, animated: false, completion: nil)
    }
    
    func animateSettingsIconWithDuration(duration: Double) {
        let settingsView: UIView = settingsIcon.valueForKey("view") as! UIView
        UIView.animateWithDuration(duration, animations: {
            settingsView.transform = CGAffineTransformMakeRotation((90.0 * CGFloat(M_PI)) / 90.0)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //This function will disable the task and add overlay image
    //boolean taskShouldBeDisable must be implemented
    
    func addDisableOverlay(cell: UITableViewCell, indexPath: Int) {
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        let yPos = cell.bounds.minY + navigationBarHeight! + statusBarHeight
        let point = CGPoint(x:cell.bounds.minX , y: yPos)
        let size = CGSize(width: cell.bounds.width, height: cell.bounds.height)
        let rect = CGRect(origin: point, size: size)
        
        let disableImage = UIImageView(frame: rect)
        disableImage.backgroundColor = UIColor.grayColor()
        disableImage.alpha = 0.5
        
        //if(taskShouldBeDisabled) {
        
        //for disable the task
        //cell.userInteractionEnabled = false
        
        //adding overlay
        self.navigationController?.view.addSubview(disableImage)
        
        //else if(!taskShouldBeDisabled) {
        //cell.userInteractionEnabled = true
        //self.navigationController?.view.willRemoveSubview(disableImage)
        
        cell.userInteractionEnabled = true
        //self.navigationController?.view.willRemoveSubview(disableImage)
    }

}



extension TaskListViewController: ORKTaskViewControllerDelegate {
    // ORKTaskViewControllerDelegate methods are handled here.
    
    
    func taskViewController(taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
        let identifier = stepViewController.step?.identifier
        
        stepViewController.skipButtonTitle = "Ønsker ikke å svare / ikke relevant"
        
        if identifier == Identifier.SleepCompletionStep.rawValue {
            stepViewController.continueButtonTitle = "Send inn"
        }
        
        if identifier == Identifier.WaitCompletionStep.rawValue {
            stepViewController.cancelButtonItem = nil
            delay(2.0, closure: { () -> () in
                if let stepViewController = stepViewController as? ORKWaitStepViewController {
                    if Reachability.isConnected() {
                        stepViewController.goForward()
                    } else {
                        stepViewController.goBackward()
                        self.showAlert("INTERNET_UNAVAILABLE_TITLE".localized, message: "INTERNET_UNAVAILABLE_TEXT".localized, taskViewController: taskViewController)
                    }
                }
            })
        }
    }
    
    
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        /*
         The `reason` passed to this method indicates why the task view
         controller finished: Did the user cancel, save, or actually complete
         the task; or was there an error?
         
         The actual result of the task is on the `result` property of the task
         view controller.
         */
        
        let taskResult = taskViewController.result
        var hoursOfSleep: Int?
        var sleepQuality: Int?
        var answerTime: NSDate?
        
        if reason == .Completed {
            if let stepResults = taskResult.results as? [ORKStepResult] {
                for stepResult in stepResults {
                    for result in stepResult.results! {
                        if result.identifier == Identifier.HoursOfSleepStep.rawValue {
                            let hoursOfSleepAnswer = result as? ORKChoiceQuestionResult
                            hoursOfSleep = (hoursOfSleepAnswer!.answer as? [Int])?[0]
                        }
                        if result.identifier == Identifier.SleepQualityStep.rawValue {
                            let sleepQualityAnswer = result as? ORKScaleQuestionResult
                            sleepQuality = sleepQualityAnswer!.answer as? Int
                            answerTime = (sleepQualityAnswer?.endDate)!
                        }
                    }
                }
            }

            UserDefaults.setObject(answerTime!, forKey: UserDefaultKey.lastDailyFormTime)
            Nettskjema.submit(hoursOfSleep, quality: sleepQuality, time: answerTime!, onFailure: { self.showAlert("UPLOAD_REQUEST_FAILED_TITLE".localized, message: "UPLOAD_REQUEST_FAILED_TEXT".localized, taskViewController: taskViewController) })
        }
        
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
}
