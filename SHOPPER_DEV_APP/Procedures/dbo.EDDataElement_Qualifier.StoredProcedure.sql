USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_Qualifier]    Script Date: 12/21/2015 14:34:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[EDDataElement_Qualifier] @parm1 varchar(15) AS Select  * from EDDataElement where segment = 'ITA' and position = '08' and code like @parm1 order by segment, position, code
GO
