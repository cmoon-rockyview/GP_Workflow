USE [MLIVE]
GO
/****** Object:  Trigger [dbo].[trgPOP10200]    Script Date: 4/6/2022 3:30:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[trgPOP10200] 
   ON  [dbo].[POP10200]
   AFTER Update
AS 
BEGIN
	
If (Update(Workflow_Status))
Begin
		
		declare @WF_Status as smallInt
		declare @DocAmnt as decimal
		declare @POPReq as varchar(50)

		declare @WF1 as varchar(31)
		declare @WF2 as varchar(31)

		select @WF_Status = Workflow_Status , @POPReq = POPRequisitionNumber 
		from inserted


		--PO Req Line
		select
		@DocAmnt =  Sum(EXTDCOST)
		from POP10210
		group by POPRequisitionNumber
		having POPRequisitionNumber like @POPReq



		Set @WF1 =
		Case 
			When @WF_Status <> 4 and @WF_Status <> 6 Then 'Not Submitted'
			When @WF_Status = 4 Then 'Submitted'
			When @WF_Status = 6 Then 'Completed'
		End

		Set @WF2 =
		Case 
			When @WF_Status <> 4 and @WF_Status <> 6 Then 'Submission'
			When @WF_Status = 4 Then 'Manager Approval'
			When @WF_Status = 6 Then 'No Requirement'
		End
		
		
		if (@WF_Status = 4 and @DocAmnt >= 4000 and @POPReq in (select W1.WfBusObjKey from WFI10002 W1
																inner JOin (select * from  WFI10003  where Workflow_Step_Name like 'Director Approval') W2
																on W1.WorkflowInstanceID = w2.WorkflowInstanceID
																where W1.Workflow_Status = 4 ) )
			Set @WF2 = 'Director Approval'
			
		Update u set u.USERDEF1 = @WF1, U.USERDEF2 = @WF2
		from dbo.POP10200 u
		inner Join inserted i on u.[DEX_ROW_ID] = i.[DEX_ROW_ID]


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	if (@WF_Status = 4 or @WF_Status = 6)
	Begin
		print 'Set Style'

	End
	
	
	if (@WF_Status = 4)
	Begin
		
		--select * from WFI10002

		declare @RequistionDesc as varchar(150)
		declare @RequstorFullName as varchar(150)
		declare @RequestedBy as varchar(50)
		declare @ToMail varchar(50)
		declare @ReportsToFullName varchar(150)

		select @RequestedBy = Rtrim(Replace(Workflow_Originator, 'ROCKYVIEW\', ''))
		from WFI10002
		where Rtrim(WfBusObjKey) = Rtrim( @POPReq)


		if (@WF2 = 'Manager Approval')
		Begin
			select @ReportsToFullName = ReportsToFullName, @ToMail = ReportsToEmail,@RequstorFullName = FullName
			from RV.TrainingReportsTo
			where LoginName = @RequestedBy
		End
		else
		Begin
			select @ReportsToFullName = ReportsToFullName2, @ToMail = ReportsToEMail2, @RequstorFullName = FullName
			from RV.TrainingReportsTo
			where LoginName = @RequestedBy
		End


		EXEC dbo.RV_SendPR @WF2 = @WF2, @RequistionDesc = @RequistionDesc, @RequstorFullName = @RequstorFullName, @RequestedBy = @RequestedBy
		
						,@ToMail =  @ToMail , @ReportsToFullName = @ReportsToFullName, @POPReq =  @POPReq
		
	

		End
	
	else if (@WF_Status = 6)
	Begin
		
		print 'test'
	End

End-- If Status is changed.
END