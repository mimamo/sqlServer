USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_spkLB]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_spkLB]  @parm1 varchar (16)  as
SELECT * from PJPROJ
WHERE
status_pa = 'A' and
status_lb = 'A' and
project like @parm1
ORDER BY
project
GO
