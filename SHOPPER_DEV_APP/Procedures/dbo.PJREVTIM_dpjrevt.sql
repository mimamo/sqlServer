USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVTIM_dpjrevt]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVTIM_dpjrevt] @parm1 varchar (16) , @parm2 varchar (4) , @parm3 varchar (32)  as
Delete    from PJREVTIM
WHERE      project = @parm1 and
revid = @parm2 and
pjt_entity = @parm3
GO
