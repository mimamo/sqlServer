USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SMServCall_Invoice_All]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[SMServCall_Invoice_All] @parm1 varchar(10) as
select * from SMServCall where InvoiceNumber like @parm1
order by InvoiceNumber
GO
