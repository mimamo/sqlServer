USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJRESTIM_dpjres]    Script Date: 12/21/2015 14:17:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRESTIM_dpjres] @parm1 varchar (16) , @parm2 varchar (32) , @parm3 varchar (16)  as
DELETE from PJRESTIM
WHERE       PJRESTIM.project    = @parm1 and
PJRESTIM.pjt_entity = @parm2 and
PJRESTIM.acct       = @parm3
GO
