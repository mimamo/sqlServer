USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ItemHist_First_Intran]    Script Date: 12/21/2015 13:44:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ItemHist_First_Intran] @Parm1 Char(30), @Parm2 Char(10)
As
Select Fiscyr,PerPost
  from IntranFirst_Fiscyr_Period
  where Invtid =  @Parm1
    and Siteid = @Parm2
GO
