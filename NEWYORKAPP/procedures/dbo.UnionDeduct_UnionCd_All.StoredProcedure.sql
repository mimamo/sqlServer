USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[UnionDeduct_UnionCd_All]    Script Date: 12/21/2015 16:01:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[UnionDeduct_UnionCd_All] @parm1 varchar (10) as
       Select * from UnionDeduct
               where Union_Cd  like @parm1
            Order by Union_Cd, DedId, Labor_Class_Cd
GO
