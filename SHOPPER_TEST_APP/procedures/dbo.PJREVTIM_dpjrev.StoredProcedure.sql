USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVTIM_dpjrev]    Script Date: 12/21/2015 16:07:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVTIM_dpjrev] @parm1 varchar (16) , @parm2 varchar (4)  as
Delete    from PJREVTIM
WHERE      project = @parm1 and
revid = @parm2
GO
