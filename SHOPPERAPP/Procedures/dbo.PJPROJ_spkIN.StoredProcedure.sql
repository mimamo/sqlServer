USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_spkIN]    Script Date: 12/21/2015 16:13:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_spkIN]  @parm1 varchar (16)  as
SELECT * from PJPROJ
WHERE    status_in = 'A' and
status_pa = 'A' and
project like @parm1
ORDER BY project
GO
