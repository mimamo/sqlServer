USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SMServCall_Invoice_All]    Script Date: 12/21/2015 16:07:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[SMServCall_Invoice_All] @parm1 varchar(10) as
select * from SMServCall where InvoiceNumber like @parm1
order by InvoiceNumber
GO
