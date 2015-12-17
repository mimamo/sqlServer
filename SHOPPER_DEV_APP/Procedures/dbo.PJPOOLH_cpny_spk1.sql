USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPOOLH_cpny_spk1]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PJPOOLH_cpny_spk1] @parm1 varchar (10), @parm2 varchar (6), @parm3 varchar (6) as
  select * from pjpoolh
   where
    cpnyid = @parm1 and
    grpid = @parm2 and
    period = @parm3
GO
