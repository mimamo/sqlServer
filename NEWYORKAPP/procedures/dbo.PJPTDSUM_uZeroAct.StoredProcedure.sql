USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDSUM_uZeroAct]    Script Date: 12/21/2015 16:01:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDSUM_uZeroAct] @parm1 varchar (16) as
Update PJPTDSUM set
act_amount = 0,
act_units = 0
WHERE
project like @parm1
GO
