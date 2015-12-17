USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVTIM_sCurrAmt]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVTIM_sCurrAmt]  @parm1 varchar (16) ,  @parm2 varchar (6)  as
SELECT  *    from PJREVTIM
WHERE
Project = @parm1 and
fiscalno Like @parm2 and
(amount <> 0 or units <> 0)
GO
