USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIGProdCode_All]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[xIGProdCode_All]
@parm1 varchar(30),
@parm2 varchar(4)
AS
Select * from xIGProdCode 
Where Code_Group Like @parm1 AND Code_Id Like @parm2
Order by Code_Group, Code_Id
GO
