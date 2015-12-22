-- find orphaned logins

--Error 15023: User already exists in current database.

--1) This is the best Solution.
--First of all run following T-SQL Query in Query Analyzer. This will return all the existing users in database in result pan.
USE YourDB
GO
EXEC sp_change_users_login 'Report'
GO

--Run following T-SQL Query in Query Analyzer to associate login with the username. ‘Auto_Fix’ attribute will create the user in SQL Server instance if it does not exist. In following example ‘ColdFusion’ is UserName, ‘cf’ is Password. Auto-Fix links a user entry in the sysusers table in the current database to a login of the same name in sysxlogins.
USE YourDB
GO
EXEC sp_change_users_login 'Auto_Fix', 'ColdFusion', NULL, 'cf'
GO

--Run following T-SQL Query in Query Analyzer to associate login with the username. ‘Update_One’ links the specified user in the current database to login. login must already exist. user and login must be specified. password must be NULL or not specified
USE YourDB
GO
EXEC sp_change_users_login 'update_one', 'ColdFusion', 'ColdFusion'
GO

--2) If login account has permission to drop other users, run following T-SQL in Query Analyzer. This will drop the user.
USE YourDB
GO
EXEC sp_dropuser 'ColdFusion'
GO


--- After Proceedures are created run them
EXEC spDBA_FixOrphanUsers
EXEC spDBA_FixOrphanUsersPassWord
EXEC spDBA_DropOrphanUsers

--Create the same user again in the database without any error.

--Stored Procedure 1:
/*Following Stored Procedure will fix all the Orphan users in database
by mapping them to username already exist for user on server.
This SP is required when user has been created at server level but does
not show up as user in database.*/
CREATE PROCEDURE dbo.spDBA_FixOrphanUsers
AS
DECLARE @username VARCHAR(25)
DECLARE GetOrphanUsers CURSOR
FOR
SELECT UserName = name
FROM sysusers
WHERE issqluser = 1
AND (sid IS NOT NULL
AND sid <> 0x0)
AND SUSER_SNAME(sid) IS NULL
ORDER BY name
OPEN GetOrphanUsers
FETCH NEXT
FROM GetOrphanUsers
INTO @username
WHILE @@FETCH_STATUS = 0
BEGIN
IF @username='dbo'
EXEC sp_changedbowner 'sa'
ELSE
EXEC sp_change_users_login 'update_one', @username, @username
FETCH NEXT
FROM GetOrphanUsers
INTO @username
END
CLOSE GetOrphanUsers
DEALLOCATE GetOrphanUsers
GO

--Stored Procedure 2:
/*Following Stored Procedure will fix all the Orphan users in database
by creating the server level user selecting same password as username.
Make sure that you change all the password once users are created*/
CREATE PROCEDURE dbo.spDBA_FixOrphanUsersPassWord
AS
DECLARE @username VARCHAR(25)
DECLARE @password VARCHAR(25)
DECLARE GetOrphanUsers CURSOR
FOR
SELECT UserName = name
FROM sysusers
WHERE issqluser = 1
AND (sid IS NOT NULL
AND sid <> 0x0)
AND SUSER_SNAME(sid) IS NULL
ORDER BY name
OPEN GetOrphanUsers
FETCH NEXT
FROM GetOrphanUsers
INTO @username
SET @password = @username
WHILE @@FETCH_STATUS = 0
BEGIN
IF @username='dbo'
EXEC sp_changedbowner 'sa'
ELSE
EXEC sp_change_users_login 'Auto_Fix', @username, NULL, @password
FETCH NEXT
FROM GetOrphanUsers
INTO @username
END
CLOSE GetOrphanUsers
DEALLOCATE GetOrphanUsers
GO

--Stored Procedure 3:
----Following Stored Procedure will drop all the Orphan users in database.
----If you need any of those users, you can create them again.
CREATE PROCEDURE dbo.spDBA_DropOrphanUsers
AS
DECLARE @username VARCHAR(25)
DECLARE GetOrphanUsers CURSOR
FOR
SELECT UserName = name
FROM sysusers
WHERE issqluser = 1
AND (sid IS NOT NULL
AND sid <> 0x0)
AND SUSER_SNAME(sid) IS NULL
ORDER BY name
OPEN GetOrphanUsers
FETCH NEXT
FROM GetOrphanUsers
INTO @username
WHILE @@FETCH_STATUS = 0
BEGIN
IF @username='dbo'
EXEC sp_changedbowner 'sa'
ELSE
EXEC sp_dropuser @username
FETCH NEXT
FROM GetOrphanUsers
INTO @username
END
CLOSE GetOrphanUsers
DEALLOCATE GetOrphanUsers
GO