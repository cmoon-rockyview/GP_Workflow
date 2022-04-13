USE [PAFD]
GO

/****** Object:  View [RV].[VW_TrainingReportsTo]    Script Date: 4/13/2022 9:31:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE View [RV].[VW_TrainingReportsTo]
as

	select 
	E.[Id]
      ,E.[EmployeeId] 
      ,E.[RVEmployeeId]
	  ,E.EmpIdNoZero
      ,E.[FirstName]
      ,E.[LastName]
      ,E.[PreferredName]
      ,E.[FullName]
      ,E.[LoginName]
      ,E.[EMail]
      ,E.[Section]
      ,E.[Locn]
      ,E.[Department]
      ,E.[PositionCode]
      ,E.[PositionDesc]
      ,E.[WorkZone]
      ,E.[Building]
      ,E.[Phone]
      ,E.[GLCode]
	  ,E.Status
	  ,E.Picture
	  ,E.AccessiblePositions
	  ,E.AccessibleLogins
	  

	  ,E.ReportsTo2 as ReportsTo
	  ,(select PositionDesc from RV.Employee where PositionCode = E.ReportsTo2) as ReportsToDesc

	  ,M.[EmployeeId] as ReportsToEmpId
      ,M.[FirstName] as ReportsToFirstName
      ,M.[LastName] as ReportsToLastName
      ,M.[PreferredName] as ReportsToPreferredName
      ,M.[FullName] as ReportsToFullName
      ,M.[LoginName] as ReportsToLogin
	  ,M.EMail as ReportsToEMail
	  ,M.Phone as ReportsToPhone

	  ,(select PositionCode from RV.Employee where PositionCode = M.DivisionNum) as ReportsTo2
	  ,(select PositionDesc from RV.Employee where PositionCode = M.DivisionNum) as ReportsToDesc2
	  ,(select EmployeeId from RV.Employee where PositionCode = M.DivisionNum) as ReportsToEmpId2
	  ,(select FirstName from RV.Employee where PositionCode = M.DivisionNum) as ReportsToFirstName2
	  ,(select LastName from RV.Employee where PositionCode = M.DivisionNum) as ReportsToLastName2
	  ,(select PreferredName from RV.Employee where PositionCode = M.DivisionNum) as ReportsToPreferredName2
	  ,(select FullName from RV.Employee where PositionCode = M.DivisionNum) as ReportsToFullName2
	  ,(select LoginName from RV.Employee where PositionCode = M.DivisionNum) as ReportsToLogin2
	  ,(select EMail from RV.Employee where PositionCode = M.DivisionNum) as ReportsToEMail2
	  ,(select Phone from RV.Employee where PositionCode = M.DivisionNum) as ReportsToPhone2



	from RV.Employee E

	inner Join (select * from RV.Employee where PositionType = 'Manager') M
	on E.ReportsTo2 = M.PositionCode
	where E.loginName not like '%NoLogin%' and Len(E.LoginName) > 3 and E.EmployeeId not like 'No EmpId'


Union All

	select 
	   E.[Id]
      ,E.[EmployeeId] 
      ,E.[RVEmployeeId]
	  ,E.EmpIdNoZero
      ,E.[FirstName]
      ,E.[LastName]
      ,E.[PreferredName]
      ,E.[FullName]
      ,E.[LoginName]
      ,E.[EMail]
      ,E.[Section]
      ,E.[Locn]
      ,E.[Department]
      ,E.[PositionCode]
      ,E.[PositionDesc]
      ,E.[WorkZone]
      ,E.[Building]
      ,E.[Phone]
      ,E.[GLCode]
	  ,E.Status
	  ,E.Picture
	  ,E.AccessiblePositions
	  ,E.AccessibleLogins

	  ,E.ReportsTo as ReportsTo
	  ,E.ReportsToDesc as ReportsToDesc

	  ,M.[EmployeeId] as ReportsToEmpId
      ,M.[FirstName] as ReportsToFirstName
      ,M.[LastName] as ReportsToLastName
      ,M.[PreferredName] as ReportsToPreferredName
      ,M.[FullName] as ReportsToFullName
      ,M.[LoginName] as ReportsToLogin
	  ,M.EMail as ReportsToEMail
	  ,M.Phone as ReportsToPhone

	  ,(select PositionCode from RV.Employee where PositionCode = M.DivisionNum) as ReportsTo2
	  ,(select PositionDesc from RV.Employee where PositionCode = M.DivisionNum) as ReportsToDesc2
	  ,(select EmployeeId from RV.Employee where PositionCode = M.DivisionNum) as ReportsToEmpId2
	  ,(select FirstName from RV.Employee where PositionCode = M.DivisionNum) as ReportsToFirstName2
	  ,(select LastName from RV.Employee where PositionCode = M.DivisionNum) as ReportsToLastName2
	  ,(select PreferredName from RV.Employee where PositionCode = M.DivisionNum) as ReportsToPreferredName2
	  ,(select FullName from RV.Employee where PositionCode = M.DivisionNum) as ReportsToFullName2
	  ,(select LoginName from RV.Employee where PositionCode = M.DivisionNum) as ReportsToLogin2
	  ,(select EMail from RV.Employee where PositionCode = M.DivisionNum) as ReportsToEMail2
	  ,(select Phone from RV.Employee where PositionCode = M.DivisionNum) as ReportsToPhone2



	from RV.Employee E
	inner Join (select * from RV.Employee where PositionType = 'Manager') M
	on E.ReportsTo = M.PositionCode
	where E.loginName not like '%NoLogin%' and Len(E.LoginName) > 3 and E.EmployeeId not like 'No EmpId'
Union All

	SELECT 
	   [Id]
      ,[EmployeeId]
      ,[RVEmployeeId]
	  ,EmpIdNoZero
      ,[FirstName]
      ,[LastName]
      ,[PreferredName]
      ,[FullName]
      ,[LoginName]
      ,[EMail]
      ,[Section]
      ,[Locn]
      ,[Department]
      ,[PositionCode]
      ,[PositionDesc]
      ,[WorkZone]
      ,[Building]
      ,[Phone]
      ,[GLCode]
	  ,E.Status
	  ,E.Picture
	  ,E.AccessiblePositions
	  ,E.AccessibleLogins


      ,[ReportsTo]
	  ,ReportsToDesc
      ,[ReportsToEmpId]
      ,[ReportsToFirstName]
      ,[ReportsToLastName]
      ,[ReportsToPreferredName]
      ,[ReportsToFullName]
      ,[ReportsToLogin]
      ,[ReportsToEMail]
      ,[ReportsToPhone]
      ,[ReportsTo2]
	  ,[ReportsTo2] as ReportsToDesc2
      ,[ReportsToEmpId2]
      ,[ReportsToFirstName2]
      ,[ReportsToLastName2]
      ,[ReportsToPreferredName2]
      ,[ReportsToFullName2]
      ,[ReportsToLogin2]
      ,[ReportsToEMail2]
      ,[ReportsToPhone2]

from RV.Employee E
where PositionType like 'Manager' and E.loginName not like '%NoLogin%' and Len(E.LoginName) > 3 and E.EmployeeId not like 'No EmpId'
GO


