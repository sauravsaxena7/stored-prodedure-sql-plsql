SELECT top 1 name FROM [HAModuleUAT].[ops].[Admin] where id=1

 Select * from userlogin where UserLoginId=315 order by 1 desc

 --ISNULL(UL.UnblockByAdminId,0) AS UnblockByAdminId,
--ISNULL((SELECT top 1 name FROM [HAModuleUAT].[ops].[Admin] where id=UL.UnblockByAdminId),'') AS UnblockByAdminName

--Alter Table userlogin drop column InActiveByAdminId , UnBlockByName

ALTER TABLE USERLOGIN ADD UnblockByAdminId BIGINT
ALTER TABLE USERLOGIN ADD UserInActiveByAdminId BIGINT

--T ->CREDENTIAL TRIGGERED
--V->CREDENTIAL TRIGGERED-> PASSWORED RESET->ACCOUNT NOT LOGIN YET
--A->LOGIN -> ACTIVE ACCOUNT
--I-> ACCOUNT INACTIVE
--L-> WRONG PASSWORD MULTIPLE TIMES BLOCK USER


