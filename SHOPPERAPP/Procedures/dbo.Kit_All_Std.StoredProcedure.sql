USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Kit_All_Std]    Script Date: 12/21/2015 16:13:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Kit_All_Std] @Parm1 varchar ( 30) as
            Select *
                From Kit K Join Inventory I
                         On K.KitId = I.InvtId
                Where K.KitId like @Parm1
                  And I.ValMthd = 'T'
                Order By KitId
GO
