USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_Services]    Script Date: 12/21/2015 16:13:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[EDDataElement_Services] @parm1 VARCHAR(15)  AS Select  * from EDDataElement where segment = 'ITA' and position = '03' and code like @parm1 order by segment, position, code
GO
