USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDI_DataElement_Purpose]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[EDI_DataElement_Purpose] @parm1 varchar(15) AS Select  * from  EDDataelement where segment = 'BEG' and position = '01' and code like @parm1 order by segment, position, code
GO
