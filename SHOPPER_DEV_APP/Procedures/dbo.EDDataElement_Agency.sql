USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_Agency]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[EDDataElement_Agency] @parm1 varchar(15)  AS Select  * from EDDataElement where segment = 'ITA' and position = '02' and code like @parm1 order by segment, position, code
GO
