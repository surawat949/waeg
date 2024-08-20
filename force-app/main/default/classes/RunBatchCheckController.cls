/*
Copyright (c) 2011 salesforce.com, inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. The name of the author may not be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

By: Chris Kemp <ckemp@salesforce.com>
*/

global with sharing class RunBatchCheckController implements Schedulable {
    public static PageReference run() {
        RunBatchCheckController.execute(null);
        PageReference pageRef = Page.RunBatchCheckSuccess;
        pageRef.setRedirect(true);
        return pageRef;
    }

    /**
     * Surawat <<surawat.sakulmontreechai@hoya.com>>
     * We can't use syntax global static pulic void if api is 55.0
     * https://developer.salesforce.com/forums/?id=9062I000000DMxiQAG
     * Use global static void instead
     * 
     * global static public void execute(SchedulableContext sc) {
        ChatterGameGoalAchievement.checkFollows();
        ChatterGameGoalAchievement.checkLikes();
    }
     */
    
    global static void execute(SchedulableContext sc) {
        ChatterGameGoalAchievement.checkFollows();
        ChatterGameGoalAchievement.checkLikes();
    }

    /*
    - Changed log
    - Separate test class instead to compliance with Salesforce
    - Surawat amend 2023-11-16 <<surawat.sakulmontreechai@hoya.com>>
    static testMethod void testScheduledRun() {
        PageReference pageRef = RunBatchCheckController.run();
        System.assert(null != pageRef);
    }
    */
    
}