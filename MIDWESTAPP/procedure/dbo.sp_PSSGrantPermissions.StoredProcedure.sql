USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[sp_PSSGrantPermissions]    Script Date: 12/21/2015 15:55:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PSSGrantPermissions]
	@ObjectType VARCHAR(5), @ObjectName SYSNAME
	AS

SET @ObjectName = LTRIM(RTRIM(ISNULL(@ObjectName,'')))
SET @ObjectType = LTRIM(RTRIM(ISNULL(@ObjectType,'')))

IF EXISTS (SELECT [Name] FROM sys.SysObjects (NOLOCK) WHERE ([UID] = 1) AND ([XType] = @ObjectType) AND ([Name] = @ObjectName)) BEGIN

	DECLARE @SQLPermission VARCHAR(20), @SQLUser SYSNAME
	SET @SQLPermission = 'CONTROL'
	IF CHARINDEX('2000 - 8.', @@Version) > 0 SET @SQLPermission = 'ALL'

	--SET @SQLUser = 'MSDynamicsSL'
	--IF (dbo.fn_PSSGrantPermissions(@SQLUser) = 1)
	--	EXEC('REVOKE ' + @SQLPermission + ' ON dbo.[' + @ObjectName + '] TO [' + @SQLUser + ']')

	SET @SQLUser = 'MSDSL'
	IF (dbo.fn_PSSGrantPermissions(@SQLUser) = 1)
		EXEC('GRANT ' + @SQLPermission + ' ON dbo.[' + @ObjectName + '] TO [' + @SQLUser + ']')

	SET @SQLUser = 'master'
	IF (dbo.fn_PSSGrantPermissions(@SQLUser) = 1)
		EXEC('GRANT ' + @SQLPermission + ' ON dbo.[' + @ObjectName + '] TO [' + @SQLUser + ']')

	SET @SQLUser = 'master60sp'
	IF (dbo.fn_PSSGrantPermissions(@SQLUser) = 1)
		EXEC('GRANT ' + @SQLPermission + ' ON dbo.[' + @ObjectName + '] TO [' + @SQLUser + ']')

	SET @SQLUser = 'master80'
	IF (dbo.fn_PSSGrantPermissions(@SQLUser) = 1)
		EXEC('GRANT ' + @SQLPermission + ' ON dbo.[' + @ObjectName + '] TO [' + @SQLUser + ']')

	IF (@ObjectType IN ('U', 'V'))
		SET @SQLPermission = 'SELECT'
	ELSE
		SET @SQLPermission = 'EXECUTE'

	SET @SQLUser = 'MSDSL'
	IF (dbo.fn_PSSGrantPermissions(@SQLUser) = 1)
		EXEC('GRANT ' + @SQLPermission + ' ON dbo.[' + @ObjectName + '] TO [' + @SQLUser + ']')

	SET @SQLUser = 'masterRO'
	IF (dbo.fn_PSSGrantPermissions(@SQLUser) = 1) AND (@SQLPermission = 'SELECT')
		EXEC('GRANT ' + @SQLPermission + ' ON dbo.[' + @ObjectName + '] TO [' + @SQLUser + ']')

	SET @SQLUser = 'E7F575915A2E4897A517779C0DD7CE'
	IF (dbo.fn_PSSGrantPermissions(@SQLUser) = 1)
		EXEC('GRANT ' + @SQLPermission + ' ON dbo.[' + @ObjectName + '] TO [' + @SQLUser + ']')

	SET @SQLUser = 'E8F575915A2E4897A517779C0DD7CE'
	IF (dbo.fn_PSSGrantPermissions(@SQLUser) = 1)
		EXEC('GRANT ' + @SQLPermission + ' ON dbo.[' + @ObjectName + '] TO [' + @SQLUser + ']')

	SET @SQLUser = 'CD7359B5576446f85EB67E824B4770'
	IF (dbo.fn_PSSGrantPermissions(@SQLUser) = 1)
		EXEC('GRANT ' + @SQLPermission + ' ON dbo.[' + @ObjectName + '] TO [' + @SQLUser + ']')

	SET @SQLUser = '07718158D19D4f5f9D23B55DBF5DF1'
	IF (dbo.fn_PSSGrantPermissions(@SQLUser) = 1)
		EXEC('GRANT ' + @SQLPermission + ' ON dbo.[' + @ObjectName + '] TO [' + @SQLUser + ']')

END -- EXISTS...
GO
