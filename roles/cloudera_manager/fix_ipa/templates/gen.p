--- gen.orig	2023-09-19 02:41:24.023592604 -0700
+++ gen.patched	2023-09-19 03:42:48.196793859 -0700
@@ -39,6 +39,8 @@
 # principal name and host.
 PRINC=${PRINCIPAL%%/*}
 HOST=`echo $PRINCIPAL | cut -d "/" -f 2 | cut -d "@" -f 1`
+SERVICE_NAME=`echo $PRINCIPAL | cut -d "/" -f 1 | cut -d "@" -f 1`
+SERVICE_AND_HOST=`echo $PRINCIPAL | cut -d "@" -f 1`
 
 # Create the host if needed.
 set +e
@@ -49,7 +51,11 @@
   echo "Host $HOST exists"
 else
   echo "Adding new host: $HOST"
-  ipa host-add $HOST --force --no-reverse
+  if [[ $HOST =~ \. ]]; then
+    ipa host-add $HOST --force --no-reverse
+  else 
+    ipa host-add $HOST.{{ cluster_name }}  --force --no-reverse
+  fi
 fi
 
 set +e
@@ -62,7 +68,11 @@
 else
   PRINC_EXISTS=no
   echo "Adding new principal: $PRINCIPAL"
-  ipa service-add $PRINCIPAL --force
+  if [[ $SERVICE_AND_HOST == "${SERVICE_NAME}/${HOST}" ]]; then
+    ipa service-add $PRINCIPAL --force
+  else
+    echo "WARNING: This service does not contain a hostname, so it will not be created"
+  fi
 fi
 
 # Set the maxrenewlife for the principal, if given. There is no interface
@@ -110,4 +120,4 @@
 fi
 
 kdestroy
-exit 0
\ No newline at end of file
+exit 0
