USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PWO_Installed]    Script Date: 12/21/2015 16:07:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_PWO_Installed]
AS
	select	case when count(*) > 0
		then 1
		else 0
		end
	from	WOSetup (nolock)
	where	Init = 'Y' and
		substring(regoptions, 4, 1) = 'Y'       -- PWO switch
GO
