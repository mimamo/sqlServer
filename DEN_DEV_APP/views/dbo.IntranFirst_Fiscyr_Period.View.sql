USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[IntranFirst_Fiscyr_Period]    Script Date: 12/21/2015 14:05:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create View [dbo].[IntranFirst_Fiscyr_Period]
as
Select Invtid,
       Siteid,
       Fiscyr=Min(Fiscyr),
       PerPost=Min(PerPost)
  From Intran
  Where Fiscyr <> ' '
  Group by Invtid,Siteid
GO
