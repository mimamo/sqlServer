USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1031_IrAddOnHand]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1031_IrAddOnHand]  @siteid varchar(10), @invtid varchar(30),@ondate smalldatetime as      
select * from irAddOnHand where 
siteid = @siteid 
and invtid = @invtid
and ondate = @ondate
order by siteid
GO
