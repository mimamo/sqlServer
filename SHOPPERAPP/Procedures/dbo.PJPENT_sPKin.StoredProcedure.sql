USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_sPKin]    Script Date: 12/21/2015 16:13:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_sPKin] @parm1 varchar (16) , @PARM2 varchar (32)  as
SELECT * from PJPENT
WHERE    project =  @parm1 and
pjt_entity =  @parm2 and
status_pa = 'A' and
status_in = 'A'
ORDER BY project, pjt_entity
GO
