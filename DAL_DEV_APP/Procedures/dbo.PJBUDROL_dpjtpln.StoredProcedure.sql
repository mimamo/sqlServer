USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBUDROL_dpjtpln]    Script Date: 12/21/2015 13:35:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBUDROL_dpjtpln] @parm1 varchar (16) , @parm2 varchar (2)   as
Delete from PJBUDROL
WHERE
project = @parm1 and
plannBR = @parm2
GO
