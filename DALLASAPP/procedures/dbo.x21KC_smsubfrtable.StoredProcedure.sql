USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_smsubfrtable]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_smsubfrtable]  @Classid varchar(6) , @FlatrateId varchar(10) as      
select * from smsubfrtable where 
classid = @classid 
and FlatRateId = @flatrateid
order by classid
GO
