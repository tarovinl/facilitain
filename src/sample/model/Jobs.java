package sample.model;

import java.util.Date;

public class Jobs {
    private String jobName;
    private String jobAction;
    private Date startDate;
    private String repeatInterval;

    public void setJobName(String jobName) {
        this.jobName = jobName;
    }

    public String getJobName() {
        return jobName;
    }

    public void setJobAction(String jobAction) {
        this.jobAction = jobAction;
    }

    public String getJobAction() {
        return jobAction;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setRepeatInterval(String repeatInterval) {
        this.repeatInterval = repeatInterval;
    }

    public String getRepeatInterval() {
        return repeatInterval;
    }
}
