/****** Script for SelectTopNRows command from SSMS  ******/
INSERT INTO [dbo].[SY04200]
           ([CMTSRIES]
           ,[COMMNTID]
           ,[NOTEINDX]
           ,[CMMTTEXT])

SELECT [CMTSRIES]
      ,Left( (Rtrim([COMMNTID]) + '-A'), 15) as Commtid
      ,[NOTEINDX]
      ,[CMMTTEXT]
  FROM [MLIVE].[dbo].[SY04200] S
  where CMTSRIES = 4 and Left( (Rtrim([COMMNTID]) + '-A'), 15) like '%-A' 
        and Not Exists (select 1 from [MLIVE].[dbo].[SY04200] where COMMNTID = S.COMMNTID)