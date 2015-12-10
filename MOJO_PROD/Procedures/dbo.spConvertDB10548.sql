USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10548]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10548]
	
AS

-- 100900 is the new Unapprove Timesheets right
-- I grant this right to everyone
-- so that users do not complain if they are not able to unapprove the timesheets
insert tRightAssigned (EntityType, EntityKey, RightKey)
select 'Security Group', SecurityGroupKey, 100900
from tSecurityGroup


Update tPreference Set ProductVersion = 'WMJ'
GO
