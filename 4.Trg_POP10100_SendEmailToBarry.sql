USE [MLIVE]
GO
/****** Object:  Trigger [dbo].[trgPOP10100]    Script Date: 4/6/2022 3:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER TRIGGER [dbo].[trgPOP10100]
   ON  [dbo].[POP10100]
   AFTER Update
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if Update(Commntid)

	Begin

		  -- Insert statements for trigger here

		    Declare @Commntid as varchar(15)
			Declare @PopNo as varchar(30)         
			declare @Tot as decimal(18,3)

			select  @PopNo = PONUMBER, @Tot =  [SUBTOTAL], @Commntid = COMMNTID
			from inserted
			--from POP10100
			--where PONUMBER = 'PO24099          '          

			if (@Tot >= 75000 and @Commntid like '%-A')
			Begin
		

		
			DECLARE @Style NVARCHAR(MAX)= '';

			SET @Style += +N'<style type="text/css">' + N'.tg  {border-collapse:collapse;border-spacing:0;border-color:#aaa;}'
			+ N'.tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#aaa;color:#333;background-color:#fff;}'
			+ N'.tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#aaa;color:#fff;background-color:#f38630;}'
			+ N'.tg .tg-9ajh{font-weight:bold;background-color:#68cbd0}' + N'.tg .tg-hgcj{font-weight:bold;text-align:center}'
			+ N'</style>';
	
			DECLARE @tableHTML NVARCHAR(MAX)= '';
 
			SET @tableHTML += @Style + @tableHTML + N'<H3>'+ 'Hi Barry' + ', <br/> A new Purcahse Order needs your approval (over $7,5000) </H3>' 


				+'</br><h3>PO Number: ' + @PopNo + '</h3> '

				+'<h3>Total Cost: ' + convert(varchar(30), @Tot) + '</h3> '
		

				+ '</br><h4>This email is supposed to be sent to BWoods@rockyview.ca'  +  '<h4>'

			+ N'<table class="tg">' --DEFINE TABLE
				+ N'<table class="tg">' --DEFINE TABLE
		


			EXEC msdb.dbo.sp_send_dbmail @profile_name='GP Service', @recipients='cmoon@rockyview.ca;AAsWar@rockyview.ca', 
									@subject = 'Please Approve the Purchase Order', 
									@body = @tableHTML, @body_format = 'HTML'
		
		End


	End


  

END
