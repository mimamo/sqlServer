USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPOOLH_spk1]    Script Date: 12/21/2015 14:34:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PJPOOLH_spk1] @parm1 varchar (6), @parm2 varchar (6) as
  select * from pjpoolh
   where
    grpid = @parm1 and
    period = @parm2
GO
