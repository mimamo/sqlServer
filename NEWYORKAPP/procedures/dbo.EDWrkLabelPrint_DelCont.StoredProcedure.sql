USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkLabelPrint_DelCont]    Script Date: 12/21/2015 16:01:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDWrkLabelPrint_DelCont] @ContainerId varchar(10) As
Delete From EDWrkLabelPrint Where ContainerId = @ContainerId
GO
