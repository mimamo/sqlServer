USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDOutbound_Cust_ASN]    Script Date: 12/21/2015 15:42:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDOutbound_Cust_ASN] @parm1 varchar(15)  AS

select * from EDOutbound where custid = @parm1 and  Trans in ('856','857')
GO
