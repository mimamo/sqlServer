USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJ_PRP_Installed]    Script Date: 12/21/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PJ_PRP_Installed]
/* PRP-PA Integration. This is a the proc that determines if SK - PRP is installed */
AS
if exists (select * from sysobjects where id = object_id('dbo.XRPSetup') and sysstat & 0xf = 3)
	SELECT	Case When count(*) > 0 then 1 else 0 end
	FROM	XRPSetup (nolock)
	WHERE   Init = 'Y'
	else
 SELECT 0
GO
