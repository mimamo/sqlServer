USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVCAT_dpjrev]    Script Date: 12/21/2015 15:43:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVCAT_dpjrev] @parm1 varchar (16) , @parm2 varchar (4)  as
Delete  from PJREVCAT
WHERE       pjrevcat.project = @parm1 and
pjrevcat.revid = @parm2
GO
