USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDD_PR_Installed]    Script Date: 12/21/2015 16:01:23 ******/
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
