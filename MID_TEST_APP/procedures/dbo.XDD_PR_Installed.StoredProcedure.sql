USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDD_PR_Installed]    Script Date: 12/21/2015 15:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDD_PR_Installed]
AS
	select 		case when count(*) > 0
  			then 1
  			else 0
  			end
 	from 		PRSetup (nolock)
GO
