USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xsp_xATABLES]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xsp_xATABLES]@parm1 varchar(4),@parm2 varchar(20),@parm3 varchar(1)WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'ASSelect * From xvs_xATABLES WHERE Module LIKE @parm1 AND TableName LIKE @parm2 AND AuditTable LIKE @Parm3  Order By TableName
GO
