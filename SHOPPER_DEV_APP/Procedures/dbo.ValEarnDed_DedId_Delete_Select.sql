USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ValEarnDed_DedId_Delete_Select]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[ValEarnDed_DedId_Delete_Select] @parm1 varchar ( 10), @parm2 varchar (4) as
       if NOT exists (select DedId from Deduction where DedId = @parm1 and CalYr <> @parm2)
           Delete valearnded from ValEarnDed Where DedId = @parm1
GO
