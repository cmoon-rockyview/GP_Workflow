USE [MLIVE]
GO
/****** Object:  StoredProcedure [dbo].[RV_SendPR]    Script Date: 4/6/2022 3:33:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	ALTER Proc [dbo].[RV_SendPR] 

		@WF2 as varchar(31),
		
		@RequistionDesc as varchar(150),
		@RequstorFullName as varchar(150),
		@RequestedBy as varchar(50),
		@ToMail varchar(50),
		@ReportsToFullName varchar(150),
		@POPReq as varchar(100)	

	as
	Begin		
		
		--Close db_cursor;


		declare @ItemDesc as varchar(100)
		declare @Quantity as varchar(100)
		declare @UnitCost as varchar(100)
		declare @ExtCost as varchar(100)
		declare @TotalCost as varchar(100)

		
		select @TotalCost = Convert(varchar(100), Sum(EXTDCOST)) 
		from POP10210 
		where POPRequisitionNumber = @POPReq


		--https://www.sqlshack.com/format-dbmail-with-html-and-css/

		DECLARE @Style NVARCHAR(MAX)= '';

		SET @Style += +N'<style type="text/css">' + N'.tg  {border-collapse:collapse;border-spacing:0;border-color:#aaa;}'
		+ N'.tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#aaa;color:#333;background-color:#fff;}'
		+ N'.tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#aaa;color:#fff;background-color:#f38630;}'
		+ N'.tg .tg-9ajh{font-weight:bold;background-color:#68cbd0}' + N'.tg .tg-hgcj{font-weight:bold;text-align:center}'
		+ N'</style>';
	
		DECLARE @tableHTML NVARCHAR(MAX)= '';
 
		SET @tableHTML += @Style + @tableHTML + N'<H3>'+ 'Hi ' + @ReportsToFullName + ', <br/> A new PO Requistion needs ' + @WF2 + '(Requested by ' + @RequstorFullName  + ') </H3>' 

			+'</br><h3>Total Cost is ' + @TotalCost + '</h3> '

			+ '<h4>This email is supposed to be sent to ' +@ToMail +  '<h4>'

		+ N'<table class="tg">' --DEFINE TABLE
			+ N'<table class="tg">' --DEFINE TABLE
	/*
	Define Column Headers and Column Span for each Header Column
	*/
		+ N'<tr>' 
		+ N'<th class="tg-hgcj" colspan="5">Requistion Info</th>' 	
		+ N'</tr>' 
	/*
	Define Column Sub-Headers
	*/
		+ N'<tr>'
		+ N'<td class="tg-9ajh">RequisitionID</td>'
		+ N'<td class="tg-9ajh">Item Desc</td>' 
		+ N'<td class="tg-9ajh">Unit Cost</td>'
		+ N'<td class="tg-9ajh">Quantity</td>'
		+ N'<td class="tg-9ajh">Ext Cost</td>
		</tr>'


		select 
		@TotalCost = Convert(varchar(100),  Sum(EXTDCOST) )
		from POP10210
		where POPRequisitionNumber = @POPReq


		Declare db_cursor Cursor for		
		select ITEMDESC, Convert(varchar(100), QTYORDER), Convert(varchar(100),  UNITCOST), Convert(varchar(100),  EXTDCOST) 
		from POP10210 
		where POPRequisitionNumber = @POPReq


		Open db_cursor


		FETCH NEXT FROM db_cursor INTO @ItemDesc, @UnitCost , @Quantity , @ExtCost


		WHILE @@FETCH_STATUS = 0  
 
		BEGIN
		
			
			Set @tableHTML = @tableHTML

			+ N'<tr>'
			+ N'<td class="tg-9ajh">'+@POPReq+'</td>'
			+ N'<td class="tg-9ajh">'+@ItemDesc+'</td>' 
			+ N'<td class="tg-9ajh">'+@UnitCost+'</td>'
			+ N'<td class="tg-9ajh">'+@Quantity+'</td>'
			+ N'<td class="tg-9ajh">'+@ExtCost+'</td>
			</tr>'


		

			
			FETCH NEXT FROM db_cursor INTO @ItemDesc, @UnitCost , @Quantity , @ExtCost
		
		END


		Close db_cursor;

		deallocate db_cursor

	
		

		EXEC msdb.dbo.sp_send_dbmail @profile_name='GP Service', @recipients='cmoon@rockyview.ca;aaswar@rockyview.ca', 
									 @subject = 'New Purchase Requisition has been submitted', 
									 @body = @tableHTML, @body_format = 'HTML'




End