USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_AROM]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_AROM]   @parm1 varchar (16) as
SELECT * from PJPROJ
WHERE    status_pa = "A" and
status_ar = "A" and
project like @parm1
ORDER BY project
GO
