USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPOOLH_cpny_spk1]    Script Date: 12/21/2015 16:13:19 ******/
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
