USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xsp_xATABLES_TableName]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xsp_xATABLES_TableName]@parm1 varchar(4)WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'ASSelect TableName From xvs_xATABLES Where xvs_xATABLES.Module LIKE @parm1
GO
