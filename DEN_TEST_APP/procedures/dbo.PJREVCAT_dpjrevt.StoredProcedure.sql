USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVCAT_dpjrevt]    Script Date: 12/21/2015 15:37:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVCAT_dpjrevt] @parm1 varchar (16) , @parm2 varchar (4) , @parm3 varchar (32)  as
Delete  from PJREVCAT
WHERE       project = @parm1 and
revid = @parm2 and
pjt_entity = @parm3
GO
