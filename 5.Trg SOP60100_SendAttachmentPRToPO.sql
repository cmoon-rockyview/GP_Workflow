USE [MLIVE]
GO
/****** Object:  Trigger [dbo].[trgSOP60100Add]    Script Date: 3/8/2022 2:34:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER TRIGGER [dbo].[trgSOP60100Add]
   ON  [dbo].[SOP60100]
   AFTER INSERT
AS 
			DECLARE
			@ReqNo VARCHAR(50),
			@PONo VARCHAR(50),
			@AttachmentKeyReq VARCHAR(MAX),
			@AttachmentKeyPO VARCHAR(MAX),
			@ReqIdx NUMERIC(19,5),
			@POIdx NUMERIC(19,5),
			@attachmentid char(37);

			DECLARE attachment_cursor CURSOR FOR
			SELECT DISTINCT
			--SOPNUMBE AS ReqNo,
			--CONVERT(VARCHAR(MAX), CONVERT(BINARY(4), CAST(req.Requisition_Note_Index AS INTEGER)), 2) ReqIdx,
			--p.PONUMBER,
			--CONVERT(VARCHAR(MAX), CONVERT(BINARY(4), CAST(p.PONOTIDS_1 AS INTEGER)), 2) POIdx,
			req.Requisition_Note_Index AS ReqIdx,
			p.PONOTIDS_1 AS POIdx,
			b.BusObjKey,
			'0\PM\Purchase Order\' + rtrim(p.ponumber) as 'NewKey' ,
			p.PONUMBER,
			b.Attachment_ID
			--REPLACE(b.BusObjKey, CONVERT(VARCHAR(MAX), CONVERT(BINARY(4), CAST(req.Requisition_Note_Index AS INTEGER)), 2), CONVERT(VARCHAR(MAX), CONVERT(BINARY(4), CAST(p.PONOTIDS_1 AS INTEGER)), 2) ) NewKey
			FROM
			POP10100 p
			INNER JOIN SOP60100 link ON p.PONUMBER = link.PONUMBER
			INNER JOIN POP10200 req ON link.SOPNUMBE = req.POPRequisitionNumber
			INNER JOIN CO00102 b ON req.POPRequisitionNumber =
			substring(b.BusObjKey, charindex('REQ0', b.BusObjKey), len(b.BusObjKey))

			--INNER JOIN CO00102 b
			---ON CONVERT(VARCHAR(MAX), CONVERT(BINARY(4), CAST(req.Requisition_Note_Index AS INTEGER)), 2) = SUBSTRING(b.BusObjKey, 16, 8)

			WHERE --(p.PONUMBER = @PONo OR @PONo IS NULL) AND
			'0\PM\Purchase Order\' + rtrim(p.ponumber) NOT IN (SELECT BusObjKey FROM CO00102) ;

			OPEN attachment_cursor;
			FETCH NEXT FROM attachment_cursor
			INTO @ReqIdx, @POIdx, @AttachmentKeyReq, @AttachmentKeyPO, @pono, @attachmentid

			-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
			WHILE @@FETCH_STATUS = 0
			BEGIN

			INSERT INTO [dbo].[CO00102]
			([BusObjKey]
			,[Attachment_ID]
			,[CRUSRID]
			,[CREATDDT]
			,[CREATETIME]
			,[HISTRX]
			,[AllowAttachmentFlow]
			,[DELETE1]
			,[AllowAttachmentEmail]
			,[AttachmentOrigin]
			,[WorkflowStepInstanceID])
			SELECT
			@AttachmentKeyPO AS [BusObjKey]
			,[Attachment_ID]
			,[CRUSRID]
			,[CREATDDT]
			,[CREATETIME]
			,[HISTRX]
			,[AllowAttachmentFlow]
			,[DELETE1]
			,[AllowAttachmentEmail]
			,[AttachmentOrigin]
			,[WorkflowStepInstanceID]
			FROM
			CO00102
			WHERE
			BusObjKey = @AttachmentKeyReq
			AND @AttachmentKeyPO NOT IN (SELECT BusObjKey FROM CO00102);

			INSERT INTO [dbo].[CO00105]
			([BusObjKey]
			,[docnumbr]
			,[filename]
			,[STRTDSCR]
			,[Attachment_ID]
			,[CREATDDT]
			,[CREATETIME]
			,[FileType]
			,[Size]
			,[EmailAllowAttachments]
			,[ORD]
			,[DELETE1])
			SELECT
			@AttachmentKeyPO
			,@PONo
			,[filename]
			,[STRTDSCR]
			,[Attachment_ID]
			,[CREATDDT]
			,[CREATETIME]
			,[FileType]
			,[Size]
			,1
			,1
			,[DELETE1]
			FROM
			CO00105
			WHERE
			BusObjKey = @AttachmentKeyReq
			AND @AttachmentKeyPO NOT IN (SELECT BusObjKey FROM CO00105);

			update co00101 set ODESCTN = 'PO' where attachment_id = @attachmentid;

			INSERT INTO [dbo].[SY03900]
			([NOTEINDX]
			,[DATE1]
			,[TIME1]
			,[TXTFIELD])
			SELECT
			@POIdx AS [NOTEINDX]
			,[DATE1]
			,[TIME1]
			,[TXTFIELD]
			FROM
			[SY03900]
			WHERE
			[NOTEINDX] = @ReqIdx AND @POIdx NOT IN (SELECT [NOTEINDX] FROM SY03900)

			FETCH NEXT FROM attachment_cursor
			INTO @ReqIdx, @POIdx, @AttachmentKeyReq, @AttachmentKeyPO, @PONo, @attachmentid;
			END

			CLOSE attachment_cursor;
			DEALLOCATE attachment_cursor;



