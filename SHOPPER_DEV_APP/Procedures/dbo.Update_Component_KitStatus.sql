USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Update_Component_KitStatus]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[Update_Component_KitStatus] @kitid varchar(30), @kitsiteid varchar(10),
					@kitstatus varchar(1), @newkitstatus varchar (1) as
        UPDATE Component SET
		KitStatus = @NewKitStatus
	WHERE kitid = @kitid and
	      KitsiteId = @kitsiteid and
	      Kitstatus = @kitstatus
GO
