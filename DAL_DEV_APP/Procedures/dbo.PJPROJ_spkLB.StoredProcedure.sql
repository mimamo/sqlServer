USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_spkLB]    Script Date: 12/21/2015 13:35:50 ******/
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
