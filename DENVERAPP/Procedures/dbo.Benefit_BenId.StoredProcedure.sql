USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Benefit_BenId]    Script Date: 12/21/2015 15:42:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Benefit_BenId] @parm1 varchar ( 10) as
       Select * from Benefit
           where BenId LIKE @parm1
           order by BenId
GO
