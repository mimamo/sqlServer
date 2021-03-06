USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spMultiLevelBillingSeed]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMultiLevelBillingSeed]
	(
	@CompanyKey int
	)
AS --Encrypt

  /*
  || When     Who Rel      What
  || 04/01/15 RLB 10590    Created for multilevel billing
  || 09/09/15 KMC 10596    (269774) Added right 90919 for timesheets
 */
 

-- Access the calendar
IF NOT EXISTS (SELECT 1 FROM tRightLevel (nolock) WHERE CompanyKey = @CompanyKey AND Level = 1 And RightKey = 120100)
	Insert tRightLevel (RightKey, CompanyKey, Level) values (120100, @CompanyKey, 1)

-- Add New Meetings
IF NOT EXISTS (SELECT 1 FROM tRightLevel (nolock) WHERE CompanyKey = @CompanyKey AND Level = 1 And RightKey = 120200)
	Insert tRightLevel (RightKey, CompanyKey, Level) values (120200, @CompanyKey, 1)

-- Add Project Diary Notes
IF NOT EXISTS (SELECT 1 FROM tRightLevel (nolock) WHERE CompanyKey = @CompanyKey AND Level = 1 And RightKey = 1190930)
	Insert tRightLevel (RightKey, CompanyKey, Level) values (1190930, @CompanyKey, 1)

-- Edit own Project Diary Notes
IF NOT EXISTS (SELECT 1 FROM tRightLevel (nolock) WHERE CompanyKey = @CompanyKey AND Level = 1 And RightKey = 1190931)
	Insert tRightLevel (RightKey, CompanyKey, Level) values (1190931, @CompanyKey, 1)

-- Add and Edit Digital Art Reviews	
IF NOT EXISTS (SELECT 1 FROM tRightLevel (nolock) WHERE CompanyKey = @CompanyKey AND Level = 1 And RightKey = 20100)
	Insert tRightLevel (RightKey, CompanyKey, Level) values (20100, @CompanyKey, 1)

--	Add and Edit Misc Expenses
IF NOT EXISTS (SELECT 1 FROM tRightLevel (nolock) WHERE CompanyKey = @CompanyKey AND Level = 1 And RightKey = 90370)
	Insert tRightLevel (RightKey, CompanyKey, Level) values (90370, @CompanyKey, 1)

--	View the Project Specifications
IF NOT EXISTS (SELECT 1 FROM tRightLevel (nolock) WHERE CompanyKey = @CompanyKey AND Level = 1 And RightKey = 90700)
	Insert tRightLevel (RightKey, CompanyKey, Level) values (90700, @CompanyKey, 1)

--	Use Timesheets
IF NOT EXISTS (SELECT 1 FROM tRightLevel (nolock) WHERE CompanyKey = @CompanyKey AND Level = 1 And RightKey = 100100)
	Insert tRightLevel (RightKey, CompanyKey, Level) values (100100, @CompanyKey, 1)
IF NOT EXISTS (SELECT 1 FROM tRightLevel (nolock) WHERE CompanyKey = @CompanyKey AND Level = 1 And RightKey = 90919)
	Insert tRightLevel (RightKey, CompanyKey, Level) values (90919, @CompanyKey, 1)
IF NOT EXISTS (SELECT 1 FROM tRightLevel (nolock) WHERE CompanyKey = @CompanyKey AND Level = 1 And RightKey = 100130)
	Insert tRightLevel (RightKey, CompanyKey, Level) values (100130, @CompanyKey, 1)

-- Use Expenses
IF NOT EXISTS (SELECT 1 FROM tRightLevel (nolock) WHERE CompanyKey = @CompanyKey AND Level = 1 And RightKey = 100500)
	Insert tRightLevel (RightKey, CompanyKey, Level) values (100500, @CompanyKey, 1)

-- Access the File Folders 	
IF NOT EXISTS (SELECT 1 FROM tRightLevel (nolock) WHERE CompanyKey = @CompanyKey AND Level = 1 And RightKey = 50100)
	Insert tRightLevel (RightKey, CompanyKey, Level) values (50100, @CompanyKey, 1)


--	Use Timesheets
IF NOT EXISTS (SELECT 1 FROM tRightLevel (nolock) WHERE CompanyKey = @CompanyKey AND Level = 2 And RightKey = 100100)
	Insert tRightLevel (RightKey, CompanyKey, Level) values (100100, @CompanyKey, 2)
IF NOT EXISTS (SELECT 1 FROM tRightLevel (nolock) WHERE CompanyKey = @CompanyKey AND Level = 2 And RightKey = 90919)
	Insert tRightLevel (RightKey, CompanyKey, Level) values (90919, @CompanyKey, 2)
IF NOT EXISTS (SELECT 1 FROM tRightLevel (nolock) WHERE CompanyKey = @CompanyKey AND Level = 2 And RightKey = 100130)
	Insert tRightLevel (RightKey, CompanyKey, Level) values (100130, @CompanyKey, 2)
GO
